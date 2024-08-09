import mongoose from 'mongoose';

const UserDataschema=new mongoose.Schema({
     date:{
         type:Date,
         default: Date.now,
     },
    username:{
        type:String,
        required:true,
    },
    email:{
        type:String,
        required:true,
    },
    password:{
        type:String,
        required:true,
    },

    age:{
        type:Number,
    },

    weight:{
        type:Number,
    },

    waterIntake:{
        
        Sunday:{
            type:Number,
            default: 0,
        },
        Monday:{
            type:Number,
            default: 0,
        },
        Tuesday:{
            type:Number,
            default: 0,
        },
        Wednesday:{
            type:Number,
            default: 0,
        },
        Thursday:{
            type:Number,
            default: 0,
        },
        Friday:{
            type:Number,
            default: 0,
        },
        Saturday:{
            type:Number,
            default: 0,
        }

    },

    stepswalked:{
         
        Sunday:{
            type:Number,
            default: 0,
        },
        Monday:{
            type:Number,
            default: 0,
        },
        Tuesday:{
            type:Number,
            default: 0,
        },
        Wednesday:{
            type:Number,
            default: 0,
        },
        Thursday:{
            type:Number,
            default: 0,
        },
        Friday:{
            type:Number,
            default: 0,
        },
        Saturday:{
            type:Number,
            default: 0,
        }

    },

    calorieBurnt:{
       
        Sunday:{
            type:Number,
            default: 100,
        },
        Monday:{
            type:Number,
            default: 400,
        },
        Tuesday:{
            type:Number,
            default: 250,
        },
        Wednesday:{
            type:Number,
            default: 500,
        },
        Thursday:{
            type:Number,
            default: 200,
        },
        Friday:{
            type:Number,
            default: 0,
        },
        Saturday:{
            type:Number,
            default: 200,
        }


    },

    calorieConsumed:{
       
        Sunday:{
            type:Number,
            default: 0,
        },
        Monday:{
            type:Number,
            default: 0,
        },
        Tuesday:{
            type:Number,
            default: 0,
        },
        Wednesday:{
            type:Number,
            default: 0,
        },
        Thursday:{
            type:Number,
            default: 0,
        },
        Friday:{
            type:Number,
            default: 0,
        },
        Saturday:{
            type:Number,
            default: 0,
        }

    }

});
const UserData=mongoose.model('UserData',UserDataschema);
export default UserData;