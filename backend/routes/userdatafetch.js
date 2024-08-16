import express from 'express';
const router = express.Router();
import {getusercontroller,getcalorieburntcontroller,getcalorieconsumedcontroller,getstepscontroller
    ,getMealCardDetails ,getworkoutdetails,
    GetWaterIntakeController} from '../controllers/userdatafetchcontroller.js';


router.get('/getuser', getusercontroller);

router.get('/getcalorieburnt',getcalorieburntcontroller);

router.get('/getcalorieconsumed', getcalorieconsumedcontroller);

router.get('/getstepswalked',getstepscontroller );

router.get('/getwaterintake',GetWaterIntakeController );

router.get('/getworkoutdetails',getworkoutdetails);

router.get('/getmealdata',getMealCardDetails);

export default router;