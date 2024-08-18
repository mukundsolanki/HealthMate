import express from 'express';
const router = express.Router();
import authMiddleware from '../middleware/auth.js';
import {
  
  StepsWalked,
  CalorieConsumedcontroller,
  WorkDetailscontroller,
  CalorieBurntcontroller,
  WaterIntakeController,
  savemealcontroller,
  savesleepdatacontroller
} from '../controllers/userdatastorecontroller.js';

router.post('/saveusercalorieburnt', authMiddleware,CalorieBurntcontroller);
router.post('/saveusercalorieconsumed', authMiddleware,CalorieConsumedcontroller);
router.post('/saveuserstepswalked', authMiddleware,StepsWalked);
router.post('/saveuserwaterintake',authMiddleware, WaterIntakeController);
router.post('/saveworkoutdetails',authMiddleware, WorkDetailscontroller);
router.post('/savemeal',authMiddleware,savemealcontroller);
router.post('/savesleepdata',authMiddleware,savesleepdatacontroller);
export default router;