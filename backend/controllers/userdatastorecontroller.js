import UserData from '../models/userData.js';
import Workout from '../models/workoutmodel.js';
import Meal from '../models/mealmodel.js';



export const CalorieBurntcontroller=async(req,res)=>{
    const {calorie} = req.body;
    const Uid = req.user.userId;
    if (!Uid) return res.status(400).send('User ID is required');
    const day = new Date().toLocaleString('en-US', { weekday: 'long' });
    const currentDate = new Date();
    try {
        const user = await UserData.findById(Uid);
        if (user) {
            if (currentDate.toDateString() !== new Date(user.date).toDateString()) {
                user.date = currentDate;
                user.calorieBurnt[day] = calorie;
            } else {
                user.calorieBurnt[day] += calorie;
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
    const { calorie } = req.body;
    const Uid = req.user.userId;
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
    const { water } = req.body;
    const Uid = req.user.userId;
  
    if (!Uid) return res.status(400).send('User ID is required');
    if (typeof water !== 'number' || water < 0) return res.status(400).send('Invalid water intake value');
  
    const day = new Date().toLocaleString('en-US', { weekday: 'long' });
    const currentDate = new Date();
  
    try {
      const user = await UserData.findOne({ userId: Uid });
  
      if (user) {
        const lastUpdatedDate = new Date(user.date);
  
        if (currentDate.toDateString() !== lastUpdatedDate.toDateString()) {
          // Reset water intake for the new day
          user.waterIntake[day] = water;
        } else {
          // Increment water intake for the same day
          user.waterIntake[day] = (water || 0) ;
        }
  
        user.date = currentDate;  // Update the date to the current date
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
    const { steps} = req.body;
    const Uid = req.user.userId;

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
  const { activities: workouts, totalCalories } = req.body;
  const defaultWeight = 50; // Default weight in kg
  const userId = req.user.userId;

  if (!userId) {
    return res.status(400).json({ error: 'User ID is required' });
  }

  if (!Array.isArray(workouts)) {
    return res.status(400).send('Workouts data should be an array');
  }

  try {
    const currentDay = new Date().toLocaleString('en-US', { weekday: 'long' });
    const userData = await UserData.findOne({ userId: userId });

    if (!userData) {
      return res.status(404).json({ error: 'User data not found' });
    }

    if (!userData.calorieBurnt[currentDay]) {
      userData.calorieBurnt[currentDay] = 0;
    }

    userData.calorieBurnt[currentDay] = totalCalories;
    await userData.save();

    const today = new Date();
    const startOfDay = new Date(today.setHours(0, 0, 0, 0)); // Start of the day
    const endOfDay = new Date(today.setHours(23, 59, 59, 999)); // End of the day

    for (const workout of workouts) {
      const { title, time, MET } = workout;

      if (typeof time !== 'number' || isNaN(time)) {
        throw new Error('Invalid workout time');
      }
      if (typeof MET !== 'number' || isNaN(MET)) {
        console.error(`Invalid MET value received: ${MET}`);
        throw new Error('Invalid MET value');
      }

      const timeInHours = time / 3600;
      const calorieburnt = MET * defaultWeight * timeInHours;

      if (isNaN(calorieburnt) || calorieburnt < 0) {
        throw new Error('Calculated calories burnt is invalid');
      }

      const existingWorkout = await Workout.findOne({
        title,
        timeofworkout: time,
        date: { $gte: startOfDay, $lte: endOfDay }
      });

      if (existingWorkout) {
        existingWorkout.calorieburnt = Math.round(calorieburnt);
        await existingWorkout.save();
      } else {
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
    const Uid = req.user.userId;
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
export const savesleepdatacontroller=async(req,res)=>{
  const userId=req.user.userId;
  const { hours } = req.body;
  try {
      const currentDate = new Date();
      const options = { weekday: 'long' };
      const currentDay = new Intl.DateTimeFormat('en-US', options).format(currentDate);

      let userData = await UserData.findOne({ userId });

      if (!userData) {
          userData = new UserData({ userId });
      }

      userData.sleepdata[currentDay] = hours;
      await userData.save();

      res.status(200).json({ message: 'Sleep data saved successfully', data: userData.sleepdata });
  } catch (error) {
      res.status(500).json({ error: 'An error occurred while saving sleep data' });
  }
}