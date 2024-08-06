import UserData from '../models/userData';

exports.createusercontroller=async(req,res)=>{
    const { name, email, password, age, weight } = req.body;
    try {
        await new UserData({ name, age, weight, email, password }).save();
        res.status(200).send('User created');
    } catch (error) {
        res.status(500).send('Error creating user');
    }

}

exports.CalorieBurntcontroller=async(req,res)=>{
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

exports.CalorieConsumedcontroller=async(req,res)=>{
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

exports.WaterIntakecontroller=async(req,res)=>{
    const { water, Uid } = req.body;
    if (!Uid) return res.status(400).send('User ID is required');
    const day = new Date().toLocaleString('en-US', { weekday: 'long' });
    const currentDate = new Date();
    try {
        const user = await UserData.findById(Uid);
        if (user) {
            if (currentDate.toDateString() !== new Date(user.date).toDateString()) {
                user.date = currentDate;
                user.waterIntake[day] = water[day];
            } else {
                user.waterIntake[day] += water[day];
            }
            await user.save();
            res.status(200).send("Water intake updated");
        } else {
            res.status(404).send("User not found");
        }
    } catch (error) {
        res.status(500).send('Error saving water intake');
    }
}

exports.StepsWalked=async(res,req)=>{
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