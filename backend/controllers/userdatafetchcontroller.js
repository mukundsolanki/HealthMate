import UserData from '../models/userData.js';



export const getusercontroller=async(req,res)=>{
    const { Uid } = req.query;
    if (!Uid) return res.status(400).send('User ID is required');
    try {
        const user = await UserData.findById(Uid);
        if (user) {
            res.status(200).json(user);
        } else {
            res.status(404).send("User data not found by id");
        }
    } catch (error) {
        res.status(500).send("Error getting user data");
    }
}
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
   
    try {
        const userId = req.query.Uid;
        const user = await UserData.findById(userId);
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
    const { Uid } = req.query;
    if (!Uid) return res.status(400).send('User ID is required');
    try {
        const user = await UserData.findById(Uid);
        if (user) {
            const stepswalkedbyuser = user.stepswalked;
            res.status(200).json(stepswalkedbyuser);
        } else {
            res.status(404).send("User data not found");
        }
    } catch (error) {
        res.status(500).send("Error in loading steps walked data");
    }
}
export const getwaterintakecontroller=async(req,res)=>{
    const { Uid } = req.query;
    if (!Uid) return res.status(400).send('User ID is required');
    try {
        const user = await UserData.findById(Uid);
        if (user) {
            const waterintakebyuser = user.waterIntake;
            res.status(200).json(waterintakebyuser);
        } else {

            res.status(404).send("User data not found");
        }
    } catch (error) {


        res.status(500).send("Error in loading water intake data");
    }
}