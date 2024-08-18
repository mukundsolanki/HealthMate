import mongoose from 'mongoose';

const userDataSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    date:{
        type:Date,
        default:Date.now,
    },
    sleepdata: {
        Sunday: { type: Number, default: 0 },
        Monday: { type: Number, default: 0 },
        Tuesday: { type: Number, default: 0 },
        Wednesday: { type: Number, default: 0 },
        Thursday: { type: Number, default: 0 },
        Friday: { type: Number, default: 0 },
        Saturday: { type: Number, default: 0 }
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
        Sunday: { type: Number, default: 0 },
        Monday: { type: Number, default: 0 },
        Tuesday: { type: Number, default: 0 },
        Wednesday: { type: Number, default: 0},
        Thursday: { type: Number, default: 0 },
        Friday: { type: Number, default: 0 },
        Saturday: { type: Number, default: 0 }
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
