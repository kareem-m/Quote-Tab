import mongoose from "mongoose";

const TodoSchema = new mongoose.Schema({
    _id: { type: String, required: true },
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    title: { type: String, required: true },
    completed: { type: Boolean, default: false },
});

export default mongoose.models.Todo || mongoose.model("Todo", TodoSchema);
