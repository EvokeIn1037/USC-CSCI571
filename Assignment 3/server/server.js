const express = require("express");
const fs = require("fs");
const cors = require("cors");
const http = require("http");
const axios = require('axios');

const app = express();
const port = 3000;

const finnhubAPIKey = 'cnbk0qpr01qidn07ce70cnbk0qpr01qidn07ce7g'  // yli93500@usc.edu
const polygonAPIkey = 'Een2q7S8fOeFR_o7Ybbm8Nickr0PuDu8'  // yli93500@usc.edu

app.use(cors());

// // Cors configuration - Allows requests from localhost:4200
// const corsOptions = {
//     origin: "http://localhost:4200",
//     optionsSuccessStatus: 204,
//     methods: "GET, POST, PUT, DELETE",
// };

// // Use cors middleware
// app.use(cors(corsOptions));

// Middleware to parse JSON bodies
app.use(express.json());

// Endpoint to receive GET requests from Angular client
app.get('/api/data', async (req, res) => {
    try {
        const param = req.query.param;

        // Add custom headers
        const headers = {
            'Content-Type': 'application/json'
        };

        const externalAPIURL = "https://finnhub.io/api/v1/stock/profile2?symbol=" + param + "&token=" + finnhubAPIKey;

        // Make HTTP GET request with custom headers
        const response = await axios.get(externalAPIURL, { headers });

        // Extract data from the response
        const fetchedData = response.data;

        // Return fetched data in JSON format
        res.json(fetchedData);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    }
});

app.get('/api/autofill', async (req, res) => {
    try {
        const param = req.query.param;
        const externalAPIURL = "https://finnhub.io/api/v1/search?q=" + param + "&token=" + finnhubAPIKey;

        const response = await axios.get(externalAPIURL);
        const autofillRslt = response.data;

        // Reform the JSON with only "description" and "symbol"
        const reformattedJson = autofillRslt.result.filter(item => item.type === "Common Stock" && !item.symbol.includes('.')).map(({ description, symbol }) => ({ description, symbol }));

        res.json(reformattedJson);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    }
});

function timestampToDateTime(timestamp) {
    const date = new Date(timestamp * 1000); // Convert UNIX timestamp to milliseconds
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

app.get('/api/base', async (req, res) => {
    try {
        const param = req.query.param;
        // Add custom headers
        const headers = {
            'Content-Type': 'application/json'
        };
        const externalAPIURL = "https://finnhub.io/api/v1/stock/profile2?symbol=" + param + "&token=" + finnhubAPIKey;
        const lastPriceAPIURL = "https://finnhub.io/api/v1/quote?symbol=" + param + "&token=" + finnhubAPIKey;

        const currentTimeInMillis = Date.now() - 60000;
        // Convert milliseconds to seconds to get Unix timestamp
        const currentTimeInSeconds = Math.floor(currentTimeInMillis / 1000);
        const currentTimeForm = timestampToDateTime(currentTimeInSeconds);
        console.log(currentTimeForm);

        const response = await axios.get(externalAPIURL, { headers });
        const descriptionRslt = response.data;
        const response1 = await axios.get(lastPriceAPIURL, { headers });
        const lastPriceRslt = response1.data;

        const { ticker, name, exchange, logo } = descriptionRslt;
        const { c, d, dp, t } = lastPriceRslt;
        let baseRslt = { ticker, name, exchange, logo, c, d, dp, t };

        baseRslt.c = baseRslt.c.toFixed(2);
        baseRslt.d = baseRslt.d.toFixed(2);
        baseRslt.dp = baseRslt.dp.toFixed(2);

        const timestampForm = timestampToDateTime(t);
        baseRslt.timestampForm = timestampForm;

        console.log(timestampToDateTime(currentTimeInSeconds));
        console.log(timestampForm);

        if (t > currentTimeInSeconds) {
            baseRslt.op = 1;
        } else {
            baseRslt.op = 0;
        }

        console.log(baseRslt);

        res.json(baseRslt);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    }
});

function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

app.get('/api/historicalData', async (req, res) => {
    try {
        // Get the current date
        const currentDate = new Date();

        // Get the date 6 months before
        const sixMonthsBefore = new Date();
        sixMonthsBefore.setMonth(sixMonthsBefore.getMonth() - 12);
        sixMonthsBefore.setDate(sixMonthsBefore.getDate() - 3);

        // Format the dates as YYYY-MM-DD
        const formattedCurrentDate = formatDate(currentDate);
        const formattedSixMonthsBefore = formatDate(sixMonthsBefore);

        const param = req.query.param;
        // Add custom headers
        const headers = {
            'Content-Type': 'application/json'
        };
        const historicalDataAPIURL = "https://api.polygon.io/v2/aggs/ticker/" + param + "/range/1/day/" + formattedSixMonthsBefore + '/' + formattedCurrentDate + "?adjusted=true&sort=asc&apiKey=" + polygonAPIkey;

        const response = await axios.get(historicalDataAPIURL, { headers });
        const historicalDataRslt = response.data;

        console.log(historicalDataRslt);
        res.json(historicalDataRslt);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    }
});

app.get('/api/summary', async (req, res) => {
    try {
        const param = req.query.param;
        // Add custom headers
        const headers = {
            'Content-Type': 'application/json'
        };
        const externalAPIURL = "https://finnhub.io/api/v1/stock/profile2?symbol=" + param + "&token=" + finnhubAPIKey;
        const peersAPIURL = "https://finnhub.io/api/v1/stock/peers?symbol=" + param + "&token=" + finnhubAPIKey;
        const lastPriceAPIURL = "https://finnhub.io/api/v1/quote?symbol=" + param + "&token=" + finnhubAPIKey;
        
        const response = await axios.get(externalAPIURL, { headers });
        const descriptionRslt = response.data;
        const response1 = await axios.get(peersAPIURL, { headers });
        const peersRslt = { peers: (response1.data.filter(value => !value.includes('.'))) };
        const response2 = await axios.get(lastPriceAPIURL, { headers });
        const lastPriceRslt = response2.data;

        const summaryRslt = {
            h: lastPriceRslt.h,
            l: lastPriceRslt.l,
            o: lastPriceRslt.o,
            pc: lastPriceRslt.pc,
            ipo: descriptionRslt.ipo,
            finnhubIndustry: descriptionRslt.finnhubIndustry,
            weburl: descriptionRslt.weburl,
            peers: peersRslt.peers,
        };

        console.log(summaryRslt);
        res.json(summaryRslt);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    }
});

app.get('/api/hourly', async (req, res) => {
    try {
        const param = req.query.param;
        const op = req.query.op;
        let laterDate = '';
        if (op === '0')
        {
            const date = req.query.closeDate;
            laterDate = date;
        }
        else
        {
            // Create a new Date object representing the current date
            const currentDate = new Date();

            // Extract the components (year, month, day)
            const year = currentDate.getFullYear();
            const month = String(currentDate.getMonth() + 1).padStart(2, '0'); // Months are zero-based
            const day = String(currentDate.getDate()).padStart(2, '0');

            // Format the date string in 'YYYY-MM-DD' format
            laterDate = `${year}-${month}-${day}`;
        }

        const date = new Date(laterDate);

        // Subtract one day
        date.setDate(date.getDate() - 1);

        // Convert back to YYYY-MM-DD format
        const dayBefore = date.toISOString().split('T')[0];

        // Add custom headers
        const headers = {
            'Content-Type': 'application/json'
        };
        const hourlyDataAPIURL = "https://api.polygon.io/v2/aggs/ticker/" + param + "/range/1/hour/" + dayBefore + '/' + laterDate + "?adjusted=true&sort=asc&apiKey=" + polygonAPIkey;

        const response = await axios.get(hourlyDataAPIURL, { headers });
        const hourlyDataRslt = response.data;

        res.json(hourlyDataRslt);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    }

});

app.get('/api/news', async (req, res) => {
    try {
        const param = req.query.param;
        // Add custom headers
        const headers = {
            'Content-Type': 'application/json'
        };

        // Create a new Date object representing the current date
        const currentDate = new Date();

        // Extract the components (year, month, day)
        const year = currentDate.getFullYear();
        const month = String(currentDate.getMonth() + 1).padStart(2, '0'); // Months are zero-based
        const day = String(currentDate.getDate()).padStart(2, '0');
        // Format the date string in 'YYYY-MM-DD' format
        const laterDate = `${year}-${month}-${day}`;

        const date = new Date(laterDate);

        // Subtract one day
        date.setDate(date.getDate() - 1);

        // Convert back to YYYY-MM-DD format
        const eightDayBefore = date.toISOString().split('T')[0];

        const externalAPIURL = "https://finnhub.io/api/v1/company-news?symbol=" + param + "&from=" + eightDayBefore + "&to=" + laterDate + "&token=" + finnhubAPIKey;
        
        const response = await axios.get(externalAPIURL, { headers });
        const newsRsltTemp = response.data;

        const newsRslt0 = newsRsltTemp.map(({image, source, datetime, headline, summary, url}) => ({
            image,
            source,
            datetime: new Date(datetime * 1000).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
            }),
            headline,
            summary,
            url
        }));
        const newsRslt = newsRslt0.filter(item => item.image !== '');

        res.json(newsRslt);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    }
});

app.get('/api/insiderSentiment', async (req, res) => {
    try {
        const param = req.query.param;
        // Add custom headers
        const headers = {
            'Content-Type': 'application/json'
        };
        // Create a new Date object representing the current date
        const currentDate = new Date();
        // Extract the components (year, month, day)
        const year = currentDate.getFullYear();
        const month = String(currentDate.getMonth() + 1).padStart(2, '0'); // Months are zero-based
        const day = String(currentDate.getDate()).padStart(2, '0');
        // Format the date string in 'YYYY-MM-DD' format
        const laterDate = `${year}-${month}-${day}`;

        const externalAPIURL = "https://finnhub.io/api/v1/stock/insider-sentiment?symbol=" + param + "&from=2022-01-01&to=" + laterDate + "&token=" + finnhubAPIKey;
        const dataAPIURL = "https://finnhub.io/api/v1/stock/profile2?symbol=" + param + "&token=" + finnhubAPIKey;

        const response = await axios.get(externalAPIURL, { headers });
        const insiderSentimentRsltTemp = response.data;
        const response1 = await axios.get(dataAPIURL, { headers });
        const baseRslt = response1.data;

        const totalMspr = insiderSentimentRsltTemp.data.reduce((acc, currentValue) => acc + currentValue.mspr, 0);
        const totalChange = insiderSentimentRsltTemp.data.reduce((acc, currentValue) => acc + currentValue.change, 0);
        
        const insiderSentimentRslt = {
            "name": baseRslt.name,
            "totalMSPR": totalMspr,
            "totalChange": totalChange,
            "positiveMSPR": totalMspr > 0 ? totalMspr : 0,
            "positiveChange": totalChange > 0 ? totalChange : 0,
            "negativeMSPR": totalMspr < 0 ? totalMspr : 0,
            "negativeChange": totalChange < 0 ? totalChange : 0
        };

        res.json(insiderSentimentRslt);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    }
});

app.get('/api/insiderSentiment', async (req, res) => {
    try {
        const param = req.query.param;
        // Add custom headers
        const headers = {
            'Content-Type': 'application/json'
        };

        const externalAPIURL = "https://finnhub.io/api/v1/stock/recommendation?symbol=" + param + "&token=" + finnhubAPIKey;

        const response = await axios.get(externalAPIURL, { headers });
        const insiderSentimentRslt = response.data;
        
        res.json(insiderSentimentRslt);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    }
});

app.get('/api/recommendationTrends', async (req, res) => {
    try {
        const param = req.query.param;
        // Add custom headers
        const headers = {
            'Content-Type': 'application/json'
        };

        const externalAPIURL = "https://finnhub.io/api/v1/stock/recommendation?symbol=" + param + "&token=" + finnhubAPIKey;

        const response = await axios.get(externalAPIURL, { headers });
        const recommendationTrendsRslt = response.data;
        
        res.json(recommendationTrendsRslt);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    }
});

app.get('/api/earnings', async (req, res) => {
    try {
        const param = req.query.param;
        // Add custom headers
        const headers = {
            'Content-Type': 'application/json'
        };

        const externalAPIURL = "https://finnhub.io/api/v1/stock/earnings?symbol=" + param + "&token=" + finnhubAPIKey;

        const response = await axios.get(externalAPIURL, { headers });
        const earningsRslt = response.data;
        
        res.json(earningsRslt);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    }
});

// connect to MongoDB
const { MongoClient } = require("mongodb");
// Replace the uri string with your connection string.
const uri = "mongodb+srv://yli93500:YKhjGG4tfElrYU3B@cluster0.urcocd1.mongodb.net/";
const client = new MongoClient(uri);

app.get('/api/initDB', async (req, res) => {
    try {
        const param = req.query.param;
        const database = client.db('Assignment3');
        const dbCollect = database.collection('HW3');
        const initBalance = parseInt(param, 10);

        const query = { _id: "assignment3" };
        const updateDocument = { 
            $set: { 
                'balance': initBalance
            } 
        };
        const options = { upsert: true };

        await client.connect();

        const result = await dbCollect.updateOne(query, updateDocument, options);

        res.json(result);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    } finally {
        await client.close();
    }
});

app.get('/api/fetchContent', async (req, res) => {
    try {
        const param = req.query.param;
        const database = client.db('Assignment3');
        const dbCollect = database.collection('HW3');
        const initBalance = parseInt(param, 10);
        const query = { _id: "assignment3" }

        await client.connect();

        const document = await dbCollect.findOne(query);

        switch(initBalance) {
            case 0:
                var tempKey = document.balance;
                break;
            case 1:
                var tempKey = document.watchlist;
                break;
            case 2:
                var tempKey = document.portfolio;
                break;
        }

        const results = tempKey;

        res.json(results);
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    } finally {
        await client.close();
    }
});

app.get('/api/opWatchlist', async (req, res) => {
    try {
        const op = req.query.op;
        const database = client.db('Assignment3');
        const dbCollect = database.collection('HW3');
        const opOnWatchlist = op - '0';
        const t = req.query.t;
        const n = req.query.n;
        const c = parseFloat(req.query.c).toFixed(2);
        const d = parseFloat(req.query.d).toFixed(2);
        const dp = parseFloat(req.query.dp).toFixed(2);
        const watchlistData = {
            'ticker': t,
            'name': n,
            'c': c,
            'd': d,
            'dp': dp
        };
        console.log(watchlistData);
        console.log(opOnWatchlist);

        const query = { _id: "assignment3" }

        await client.connect();

        await dbCollect.updateOne(
            query,
            { $pull: { watchlist: { ticker: watchlistData.ticker } } }
        );

        if (opOnWatchlist === 1) {
            await dbCollect.updateOne(
                query,
                { $push: { watchlist: watchlistData } }
            );
        }

        res.json('Success');
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'Failed to fetch data' });
    } finally {
        await client.close();
    }
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});