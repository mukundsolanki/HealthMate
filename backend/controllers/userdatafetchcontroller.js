import UserData from '../models/userData.js';
import Meal from '../models/mealmodel.js';
import Workout from '../models/workoutmodel.js';



export const getcalorieburntcontroller=async(req,res)=>{
    try {
        const userId = req.query.Uid;
        const user = await UserData.findById(userId);
        if (!user) {
          return res.status(404).json({ error: 'User not found' });
        }
        const calorieburnt = Object.entries(user.calorieBurnt).map(([day, calories]) => ({
          day,
          calorieburnt: calories,
        }));
        res.json({ data: calorieburnt });
      } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
      }
}
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
        const user = await UserData.findById(Uid);
        if (user) {
            const stepswalkedbyuser = user.stepsWalked;
            res.status(200).json(stepswalkedbyuser);
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
      console.log(waterIntakeForToday);
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
  const now = new Date();
  const startOfDay = new Date(now.setHours(0, 0, 0, 0)); // Start of the day
  const endOfDay = new Date(now.setHours(23, 59, 59, 999)); // End of the day

  try {
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
    const now = new Date();
    const startOfDay = new Date(now.setHours(0, 0, 0, 0)); 
    const endOfDay = new Date(now.setHours(23, 59, 59, 999)); 
  
    try {
      const workoutData = await Workout.find({
        date: {
          $gte: startOfDay,
          $lte: endOfDay
        }
      });
  
      if (workoutData.length > 0) {
        res.status(200).json(workoutData);
      } else {
        res.status(404).send("Today's Workout not found");
      }
    } catch (err) {
      console.error("Error in loading workout data:", err);
      res.status(500).send("Error in loading workout data");
    }
  };
  