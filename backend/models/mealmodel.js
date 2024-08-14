import mongoose from "mongoose";

const mealSchema = new mongoose.Schema({
  date: {
    type: Date,
    default: Date.now
  },
  NameofFood: {
    type: String,
    required: true
  },
  quantity: {
    type: Number, 
    required: true
  },
  calorieconsumed: {
    type: Number
  }
});

const Meal = mongoose.model('Meal', mealSchema);
export default Meal;
