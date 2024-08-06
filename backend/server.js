import express from 'express';
const app=express();
import mongoose from 'mongoose';
import UserData from './models/userData.js';
import getroutes from './routes/userdatafetch.js';
import postroutes from './routes/userdatastore.js';

 
mongoose.connect("mongodb://localhost:27017/HeathMate");
const db=mongoose.connection;


db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', () => {
  console.log('Connected to MongoDB');
});

app.post('/',postroutes);
app.get('/',getroutes);


app.listen(3000,()=>{
  console.log("Connected to port 3000")
});