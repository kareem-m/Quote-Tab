import dbConnect from "../../lib/mongodb";
import Todo from "../../models/Todo";
import jwt from "jsonwebtoken";

export default async function handler(req, res) {
    await dbConnect();

    const authHeader = req.headers.authorization;
    if (!authHeader) return res.status(401).json({ message: "Unauthorized" });

    const token = authHeader.split(" ")[1];

    let userId;
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        userId = decoded.userId;
    } catch (err) {
        return res.status(401).json({ message: "Invalid token" });
    }

    if (req.method === "GET") {
        const todos = await Todo.find({ userId }).sort({ completed: 1 });
        return res.status(200).json(todos);
    }


    if (req.method === "POST") {
        const { _id, title } = req.body;
        if (!_id || !title) {
            return res.status(400).json({ message: "Missing fields" });
        }
        const todo = await Todo.create({ _id, title, userId });
        return res.status(201).json(todo);
    }

    if (req.method === "PUT") {
        const { id } = req.query;
        const { completed } = req.body;

        if (!id) {
            return res.status(400).json({ message: "ID required" });
        }

        const updated = await Todo.findOneAndUpdate(
            { _id: id, userId },
            { completed },
            { new: true }
        );

        if (!updated) {
            return res.status(404).json({ message: "Todo not found or not yours" });
        }

        return res.status(200).json(updated);
    }

    if (req.method === "DELETE") {
        const { id } = req.query;

        if (!id) {
            return res.status(400).json({ message: "ID required" });
        }

        const deleted = await Todo.findOneAndDelete({ _id: id, userId });

        if (!deleted) {
            return res.status(404).json({ message: "Todo not found or not yours" });
        }

        return res.status(200).json({ message: "Todo deleted" });
    }


    res.setHeader("Allow", ["GET", "POST", "PUT", "DELETE"]);

    return res.status(405).end(`Method ${req.method} Not Allowed`);
}
