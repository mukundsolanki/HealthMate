import express from 'express';
import mongoose from 'mongoose';
import fetchdata from './routes/userdatafetch.js';
import postdata from './routes/userdatastore.js';
import Meal from './models/mealmodel.js';

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
app.use('/postroutes/savemeal',async (req,res)=>{
  const mealName = req.body.mealName; 
  const quantity = req.body.quantity;
  const calorie = 100; 

  try {
    const mealData = await new Meal({
      date: new Date(), 
      NameofFood: mealName,
      quantity: quantity,
      calorieconsumed: calorie,
    }).save();

    res.status(200).send("Meal Data saved successfully");
  } catch (err) {
    console.error("Error saving meal data:", err); 
    res.status(500).send('Error saving meal data');
  }
});
app.use('/postroutes', postdata);


app.listen(3000, () => {
  console.log("Server running on port 3000");
});
