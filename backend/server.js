import express from 'express';
import mongoose from 'mongoose';
import fetchdata from './routes/userdatafetch.js';
import postdata from './routes/userdatastore.js';

const app = express();
app.use(express.json());


mongoose.connect("mongodb://localhost:27017/HeathMate", {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

const db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', () => {
  console.log('Connected to MongoDB');
});


app.use('/getroutes', fetchdata);
app.use('/postroutes', postdata);


app.listen(3000, () => {
  console.log("Server running on port 3000");
});
