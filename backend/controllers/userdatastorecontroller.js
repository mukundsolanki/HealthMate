import UserData from '../models/userData.js';
import Workout from '../models/workoutmodel.js';
import Meal from '../models/mealmodel.js';


export const createusercontroller = async (req, res) => {
    const { username, email, password, age, weight, height, gender } = req.body;
    try {
        await new UserData({
            username,
            email,
            password,
            age: parseInt(age), // Convert to number
            weight: parseInt(weight), // Convert to number
            height: parseInt(height), // Convert to number
            gender
        }).save();
        res.status(200).send('User created');
    } catch (error) {
        console.error('Error creating user:', error); // Log the error for debugging
        res.status(500).send('Error creating user');
    }
};
export const CalorieBurntcontroller=async(req,res)=>{
    const { calorie, Uid } = req.body;
    if (!Uid) return res.status(400).send('User ID is required');
    const day = new Date().toLocaleString('en-US', { weekday: 'long' });
    const currentDate = new Date();
    try {
        const user = await UserData.findById(Uid);
        if (user) {
            if (currentDate.toDateString() !== new Date(user.date).toDateString()) {
                user.date = currentDate;
                user.calorieBurnt[day] = calorie[day];
            } else {
                user.calorieBurnt[day] += calorie[day];
            }
            await user.save();
            res.status(200).send("Calorie burnt updated");
        } else {
            res.status(404).send("User not found");
        }
    } catch (error) {
        res.status(500).send('Error saving calorie burnt');
    }
}
export const CalorieConsumedcontroller=async(req,res)=>{
    const { calorie, Uid } = req.body;
    if (!Uid) return res.status(400).send('User ID is required');
    const day = new Date().toLocaleString('en-US', { weekday: 'long' });
    const currentDate = new Date();
    try {
        const user = await UserData.findById(Uid);
        if (user) {
            if (currentDate.toDateString() !== new Date(user.date).toDateString()) {
                user.date = currentDate;
                user.calorieConsumed[day] = calorie[day];
            } else {
                user.calorieConsumed[day] += calorie[day];
            }
            await user.save();
            res.status(200).send("Calorie consumed updated");
        } else {
            res.status(404).send("User not found");
        }
    } catch (error) {
        res.status(500).send('Error saving calorie consumed');
    }
}
export const WaterIntakeController = async (req, res) => {
    const { water, Uid } = req.body;

    if (!Uid) return res.status(400).send('User ID is required');
    if (typeof water !== 'number' || water < 0) return res.status(400).send('Invalid water intake value');

    const day = new Date().toLocaleString('en-US', { weekday: 'long' });
    const currentDate = new Date();

    try {
        const user = await UserData.findById(Uid);
        if (user) {
            if (currentDate.toDateString() !== new Date(user.date).toDateString()) {
                user.date = currentDate;
                user.waterIntake[day] = water;
            } else {
                user.waterIntake[day] = (user.waterIntake[day] || 0) + water;
            }
            await user.save();
            res.status(200).send("Water intake updated");
        } else {
            res.status(404).send("User not found");
        }
    } catch (error) {
        console.error(error);
        res.status(500).send('Error saving water intake');
    }
};

export const StepsWalked=async(res,req)=>{
    const { steps, Uid } = req.body;
    if (!Uid) return res.status(400).send('User ID is required');
    const day = new Date().toLocaleString('en-US', { weekday: 'long' });
    const currentDate = new Date();
    try {
        const user = await UserData.findById(Uid);
        if (user) {
            if (currentDate.toDateString() !== new Date(user.date).toDateString()) {
                user.date = currentDate;
                user.stepswalked[day] = steps[day];
            } else {
                user.stepswalked[day] += steps[day];
            }
            await user.save();
            res.status(200).send("Steps walked updated");
        } else {
            res.status(404).send("User not found");
        }
    } catch (error) {
        res.status(500).send('Error saving steps data');
    }
}
export const WorkDetailscontroller = async (req, res) => {
    const workouts = req.body;
    const defaultWeight = 50; // Default weight in kg
  
    try {
      const today = new Date();
      const startOfDay = new Date(today.setHours(0, 0, 0, 0)); // Start of the day
      const endOfDay = new Date(today.setHours(23, 59, 59, 999)); // End of the day
  
      for (const workout of workouts) {
        const { title, time, MET } = workout;
  
        // Validate inputs
        if (typeof time !== 'number' || isNaN(time)) {
          throw new Error('Invalid workout time');
        }
        if (typeof MET !== 'number' || isNaN(MET)) {
          console.error(`Invalid MET value received: ${MET}`);
          throw new Error('Invalid MET value');
        }
  
        const timeInHours = time / 3600;
        const calorieburnt = MET * defaultWeight * timeInHours;
  
        // Ensure calorieburnt is a valid number
        if (isNaN(calorieburnt) || calorieburnt < 0) {
          throw new Error('Calculated calories burnt is invalid');
        }
  
        const existingWorkout = await Workout.findOne({
          title,
          timeofworkout: time,
          date: { $gte: startOfDay, $lte: endOfDay }
        });
  
        if (existingWorkout) {
          // Update existing workout
          existingWorkout.calorieburnt = Math.round(calorieburnt);
          await existingWorkout.save();
        } else {
          // Insert new workout
          const newWorkout = new Workout({
            NameofWorkout: title,
            timeofworkout: time,
            date: new Date(),
            calorieburnt: Math.round(calorieburnt)
          });
          await newWorkout.save();
        }
      }
  
      console.log('Workouts successfully saved or updated');
      res.status(200).send("Workout Data saved or updated successfully");
    } catch (err) {
      console.error('Error in WorkDetailscontroller:', err);
      res.status(500).send(`Error saving or updating Workout data: ${err.message}`);
    }
};
  export const savemealcontroller = async (req, res) => {
    const { mealName, quantity, calorieconsumed,totalcaloriesconsumed } = req.body;
   
  
    if (!mealName || quantity == null || calorieconsumed == null) {
      return res.status(400).send("Missing required fields");
    }
  
    try {
      const mealData = new Meal({
        date: new Date(),
        NameofFood: mealName,
        quantity:quantity,
        calorieconsumed:calorieconsumed,
        totalcaloriesconsumed:totalcaloriesconsumed,
      });
  
      await mealData.save();
      res.status(200).send("Meal Data saved successfully");
    } catch (err) {
      console.error("Error saving meal data:", err);
      res.status(500).send('Error saving meal data');
    }
};
  