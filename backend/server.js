import express from 'express';
import mongoose from 'mongoose';
import fetchdata from './routes/userdatafetch.js';
import postdata from './routes/userdatastore.js';
import cors from 'cors';
import user from './routes/user.js';

const app = express();

app.use(cors());
app.use(express.json());

const PORT=3000;
mongoose.connect("mongodb://localhost:27017/HeathMate", { useNewUrlParser: true, useUnifiedTopology: true });

const db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', () => {
  console.log('Connected to MongoDB');
});

app.use('/auth',user);
app.use('/getroutes', fetchdata);

app.use('/postroutes', postdata);


app.listen(3000, '0.0.0.0', () => {
  console.log('Server is running on port 3000');
});