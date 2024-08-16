import express from 'express';
const router = express.Router();
import {
  createusercontroller,
  StepsWalked,
  CalorieConsumedcontroller,
  WorkDetailscontroller,
  CalorieBurntcontroller,
  WaterIntakeController,
  savemealcontroller
} from '../controllers/userdatastorecontroller.js';

router.post('/saveusercalorieburnt', CalorieBurntcontroller);
router.post('/createuser', createusercontroller);
router.post('/saveusercalorieconsumed', CalorieConsumedcontroller);
router.post('/saveuserstepswalked', StepsWalked);
router.post('/saveuserwaterintake', WaterIntakeController);
router.post('/saveworkoutdetails', WorkDetailscontroller);
router.post('/savemeal',savemealcontroller);

export default router;