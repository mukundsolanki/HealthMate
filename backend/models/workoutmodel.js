import mongoose from "mongoose";

const WorkoutSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
},
  date: {
    type: Date,
    default: Date.now
  },
  NameofWorkout: {
    type: String,
    required: true
  },
 
  timeofworkout: {
    type: Number, 
    required: true
  },
  calorieburnt: {
    type: Number
  }
});

const Workout = mongoose.model('Workout', WorkoutSchema);
export default Workout;
