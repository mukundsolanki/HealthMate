import mongoose from 'mongoose';

const userDataSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    waterIntake: {
        Sunday: { type: Number, default: 0 },
        Monday: { type: Number, default: 0 },
        Tuesday: { type: Number, default: 0 },
        Wednesday: { type: Number, default: 0 },
        Thursday: { type: Number, default: 0 },
        Friday: { type: Number, default: 0 },
        Saturday: { type: Number, default: 0 }
    },
    stepsWalked: {
        Sunday: { type: Number, default: 0 },
        Monday: { type: Number, default: 0 },
        Tuesday: { type: Number, default: 0 },
        Wednesday: { type: Number, default: 0 },
        Thursday: { type: Number, default: 0 },
        Friday: { type: Number, default: 0 },
        Saturday: { type: Number, default: 0 }
    },
    calorieBurnt: {
        Sunday: { type: Number, default: 100 },
        Monday: { type: Number, default: 400 },
        Tuesday: { type: Number, default: 250 },
        Wednesday: { type: Number, default: 500 },
        Thursday: { type: Number, default: 200 },
        Friday: { type: Number, default: 0 },
        Saturday: { type: Number, default: 200 }
    },
    calorieConsumed: {
        Sunday: { type: Number, default: 0 },
        Monday: { type: Number, default: 0 },
        Tuesday: { type: Number, default: 0 },
        Wednesday: { type: Number, default: 0 },
        Thursday: { type: Number, default: 0 },
        Friday: { type: Number, default: 0 },
        Saturday: { type: Number, default: 0 }
    }
}, { timestamps: true });

const UserData = mongoose.model('UserData', userDataSchema);
export default UserData;
