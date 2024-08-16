import jwt from 'jsonwebtoken';

const JWT_SECRET = 'your_jwt_secret_key'; // Ensure this matches with the one used to sign the token

const authMiddleware = (req, res, next) => {
    const authHeader = req.header('Authorization');
    if (!authHeader) {
        return res.status(401).json({ message: 'Access Denied: No token provided' });
    }

    const token = authHeader.replace('Bearer ', '');
    try {
        const decoded = jwt.verify(token, JWT_SECRET);
        req.user = decoded;
        console.log('User from token:', req.user); // Debugging line
        next();
    } catch (err) {
        res.status(400).json({ message: 'Invalid Token' });
    }
};


export default authMiddleware;
