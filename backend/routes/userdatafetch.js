import express from 'express';
const router = express.Router();
import {getusercontroller,getcalorieburntcontroller,getcalorieconsumedcontroller,getstepscontroller
    ,getwaterintakecontroller } from '../controllers/userdatafetchcontroller.js';


router.get('/getuser', getusercontroller);

router.get('/getcalorieburnt',getcalorieburntcontroller);

router.get('/getcaloriebconsumed', getcalorieconsumedcontroller);

router.get('/getstepswalked',getstepscontroller );

router.get('/getwaterintake',getwaterintakecontroller );

export default router;