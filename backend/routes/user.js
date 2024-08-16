import express from 'express';
import { handleusersignup, handleuserlogin } from '../controllers/user.js';

const router = express.Router();


router.post('/signup', handleusersignup);
router.post('/login', handleuserlogin);

export default router;
