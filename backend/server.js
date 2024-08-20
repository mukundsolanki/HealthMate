import express from 'express';
import mongoose from 'mongoose';
import fetchdata from './routes/userdatafetch.js';
import postdata from './routes/userdatastore.js';
import cors from 'cors';
import user from './routes/user.js';
import bodyParser from 'body-parser';
const app = express();

app.use(cors({
  origin: '*',  // Allow all origins
}));
app.use(bodyParser.json()); // Parse application/json
app.use(bodyParser.urlencoded({ extended: true })); // Parse application/x-www-form-urlencoded



mongoose.connect("mongodb://localhost:27017/HeathMate", { useNewUrlParser: true, useUnifiedTopology: true });

const db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', () => {
  console.log('Connected to MongoDB');
});

app.use('/auth',user);
app.use('/getroutes', fetchdata);

app.use('/postroutes', postdata);


app.listen(4000, '0.0.0.0', () => {
  console.log('Server is running on port 4000');
});