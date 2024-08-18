import UserData from '../models/userData.js';
import Meal from '../models/mealmodel.js';
import Workout from '../models/workoutmodel.js';


export const getcalorieburntcontroller = async (req, res) => {
  try {
    const userId = req.user.userId;

    if (!userId) {
      return res.status(400).json({ error: 'User ID is required' });
    }

    const user = await UserData.findOne({ userId: userId });
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
   
     
    res.status(200).json({ data: user.calorieBurnt }); 
  } catch (error) {
    console.error('Error fetching calorie burnt data:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};


export const getcalorieconsumedcontroller=async(req,res)=>{
  const Uid = req.user.userId;
    try {
        
        const user = await UserData.findById(Uid);
        if (!user) {
          return res.status(404).json({ error: 'User not found' });
        }
        const calorieConsumed = Object.entries(user.calorieConsumed).map(([day, calories]) => ({
          day,
          calorieConsumed: calories,
        }));
        res.json({ data: calorieConsumed });
      } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
      }
}
export const getstepscontroller=async(req,res)=>{
  const Uid = req.user.userId;
    if (!Uid) return res.status(400).send('User ID is required');
    try {
        
    const user = await UserData.findOne({ userId: Uid });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
   
        if (user) {
           
            res.status(200).json({data:user.stepsWalked});
        } else {
            res.status(404).send("User data not found");
        }
    } catch (error) {
        res.status(500).send("Error in loading steps walked data");
    }
}
export const GetWaterIntakeController = async (req, res) => {
  const Uid = req.user.userId;

  if (!Uid) return res.status(400).send('User ID is required');

  try {
    
    const user = await UserData.findOne({ userId: Uid });
    
    if (user) {
     
    const day = new Date().toLocaleString('en-US', { weekday: 'long' });
      const waterIntakeForToday = user.waterIntake[day]|| 0;
      
      console.log(user.waterIntake[day]);
     // console.log(waterIntakeForToday);
      res.status(200).json({ waterIntakeForToday: waterIntakeForToday });
    } else {
      res.status(404).send("User not found");
    }
  } catch (error) {
    console.error(error);
    res.status(500).send('Error fetching water intake');
  }
};

export const getMealCardDetails = async (req, res) => {
  const Uid = req.user.userId;
    if (!Uid) return res.status(400).send('User ID is required');
    try {
        
    const user = await Meal.findOne({ userId: Uid });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
  const now = new Date();
  const startOfDay = new Date(now.setHours(0, 0, 0, 0)); // Start of the day
  const endOfDay = new Date(now.setHours(23, 59, 59, 999)); // End of the day

      const mealData = await Meal.find({
          date: {
              $gte: startOfDay, // Greater than or equal to the start of the day
              $lte: endOfDay   // Less than or equal to the end of the day
          }
      });

      if (mealData.length > 0) {
          res.status(200).json(mealData);
      } else {
          res.status(404).send("Today's Meal not found");
      }
  } catch (err) {
      console.error("Error in loading meal data:", err);
      res.status(500).send("Error in loading meal data");
  }
};

export const getworkoutdetails = async (req, res) => {
  const Uid = req.user.userId;
  if (!Uid) return res.status(400).send('User ID is required');

  try {
      const startOfDay = new Date().setHours(0, 0, 0, 0);
      const endOfDay = new Date().setHours(23, 59, 59, 999);

      const workoutData = await Workout.find({
          userId: Uid,
          date: {
              $gte: startOfDay,
              $lte: endOfDay
          }
      }).sort({ timeofworkout: 1 });

      // Filter out duplicates by workout title and time
      const uniqueWorkouts = workoutData.filter((workout, index, self) =>
          index === self.findIndex((w) =>
              w.NameofWorkout === workout.NameofWorkout && w.timeofworkout === workout.timeofworkout)
      );

      if (uniqueWorkouts.length > 0) {
          res.status(200).json(uniqueWorkouts);
      } else {
          res.status(404).send("Today's workout not found");
      }
  } catch (err) {
      console.error("Error in loading workout data:", err);
      res.status(500).send("Error in loading workout data");
  }
};

  export const getsleepdatacontroller = async (req, res) => {
    const userId = req.user.userId;

    if (!userId) {
        return res.status(400).json({ error: 'User ID is required' });
    }

    try {
        const userData = await UserData.findOne({ userId });

        if (!userData) {
            return res.status(404).json({ error: 'User data not found' });
        }

        res.status(200).json({ data: userData.sleepdata });
    } catch (error) {
        res.status(500).json({ error: 'An error occurred while retrieving sleep data' });
    }
};
