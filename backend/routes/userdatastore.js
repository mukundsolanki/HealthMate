import express from 'express';
const router = express.Router();
import {createusercontroller,StepsWalked,CalorieConsumedcontroller,CalorieBurntcontroller,WaterIntakecontroller} 
from '../controllers/userdatastorecontroller.js'

router.post('/saveusercalorieburnt',CalorieBurntcontroller);

router.post('/createuser',createusercontroller  );

router.post('/saveusercalorieconsumed',CalorieConsumedcontroller);

router.post('/saveuserstepswalked',StepsWalked);

router.post('/saveuserwaterintake',WaterIntakecontroller );



export default router;