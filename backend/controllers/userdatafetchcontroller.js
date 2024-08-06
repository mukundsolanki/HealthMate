import UserData from '../models/userData';



exports.getusercontroller=async(req,res)=>{
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
exports.getcalorieburntcontroller=async(req,res)=>{
    const { Uid } = req.query;
    if (!Uid) return res.status(400).send('User ID is required');
    try {
        const user = await UserData.findById(Uid);
        if (user) {
            const calorieburntdata = user.calorieBurnt;
            res.status(200).json(calorieburntdata);
        } else {
            res.status(404).send("User data not found");
        }
    } catch (error) {
        res.status(500).send("Error in loading calorieburnt data");
    }
}
exports.getcalorieconsumedcontroller=async(req,res)=>{
    const { Uid } = req.query;
    if (!Uid) return res.status(400).send('User ID is required');
    try {
        const user = await UserData.findById(Uid);
        if (user) {
            const calorieconsumedata = user.calorieConsumed;
            res.status(200).json(calorieconsumedata);
        } else {
            res.status(404).send("User data not found");
        }
    } catch (error) {
        res.status(500).send("Error in loading calorie consumed data");
    }
}
exports.getstepscontroller=async(req,res)=>{
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
exports.getwaterintakecontroller=async(req,res)=>{
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