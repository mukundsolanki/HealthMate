import express from 'express';
const router = express.Router();
import {getusercontroller,getcalorieburntcontroller,getcalorieconsumedcontroller,getstepscontroller
    ,getwaterintakecontroller,getMealCardDetails ,getworkoutdetails} from '../controllers/userdatafetchcontroller.js';


router.get('/getuser', getusercontroller);

router.get('/getcalorieburnt',getcalorieburntcontroller);

router.get('/getcalorieconsumed', getcalorieconsumedcontroller);

router.get('/getstepswalked',getstepscontroller );

router.get('/getwaterintake',getwaterintakecontroller );

router.get('/getworkoutdetails',getworkoutdetails);

router.get('/getmealdata',getMealCardDetails);

export default router;