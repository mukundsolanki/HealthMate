import jwt from 'jsonwebtoken';
import User from '../models/user.js';
import UserData from '../models/userData.js';
const JWT_SECRET = 'your_jwt_secret_key';

// Signup Controller
export async function handleusersignup(req, res) {
    const { username, email, password ,age,gender,height} = req.body;

    try {
        const user = await User.create({ username, email, password ,age,gender,height});
        res.status(201).json({ message: 'User created successfully', userId: user._id });
    } catch (error) {
        res.status(500).json({ message: 'Error creating user', error });
    }
}



export async function handleuserlogin(req, res) {
    const { email, password } = req.body;

    try {
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ message: 'Invalid email or password' });
        }

        const isMatch = await user.matchPassword(password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid email or password' });
        }

        // Fetch or initialize user data
        let userData = await UserData.findOne({ userId: user._id });
        if (!userData) {
            userData = await UserData.create({ userId: user._id });
        }

        // Create JWT
        const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '1h' });

        res.status(200).json({
            message: 'Login successful',
            token,
            userData, // Return user data with the response
        });
    } catch (error) {
        res.status(500).json({ message: 'Error logging in', error });
    }
}
