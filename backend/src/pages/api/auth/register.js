import dbConnect from "../../../lib/mongodb";
import User from "../../../models/User";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

export default async function handler(req, res) {
    if (req.method !== "POST") {
        return res.status(405).json({ message: "Method not allowed" });
    }

    // الجزء الأهم هو ده
    try {
        await dbConnect();

        const { username, password } = req.body;

        if (!username || !password) {
            return res.status(400).json({ message: "Username and password are required" });
        }

        const existingUser = await User.findOne({ username });
        if (existingUser) {
            return res.status(400).json({ message: "Username already exists" });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const user = await User.create({ username, password: hashedPassword });
        const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET);

        res.status(201).json({ token, username: user.username });

    } catch (error) {
        // السطرين دول هيوضحوا كل حاجة
        console.error("REGISTRATION_ERROR:", error); // هتظهر في الـ Logs على Vercel
        res.status(500).json({ message: "An internal server error occurred.", error: error.message });
    }
}