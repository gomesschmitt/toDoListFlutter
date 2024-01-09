var taskService = require('./taskService');

var postTask = async (req, res) => {
    try {
        var status = await taskService.createTask(req.body.taskId);
        if (status) {
            res.send({ "status": true, "message": "Task created successfully" });
        } else {
            res.send({ "status": false, "message": "Error creating task" });
        }
    } catch (error) {
        console.error('Error creating task:', error);
        res.status(500).send({ "status": false, "message": "Internal Server Error" });
    }
}

var getAllTasks = async (req, res) => {
    try {
        var tasks = await taskService.getAllTasks();
        res.send({ "status": true, "message": "Tasks fetched successfully", data: tasks });
    } catch (error) {
        console.error('Error getting tasks:', error);
        res.status(500).send({ "status": false, "message": "Internal Server Error" });
    }
}

var deleteTask = async (req, res) => {
    try {
        var status = await taskService.removeTask(req.body.taskId);
        if (status) {
            res.send({ "status": true, "message": "Task deleted successfully" });
        } else {
            res.send({ "status": false, "message": "Error deleting task" });
        }
    } catch (error) {
        console.error('Error deleting task:', error);
        res.status(500).send({ "status": false, "message": "Internal Server Error" });
    }
}

var updateTask = async (req, res) => {
    try {
        const status = await taskService.updateTask(req.body.taskId, req.body);
        if (status.status) {
            res.send({ "status": true, "message": "Task updated successfully" });
        } else {
            res.send({ "status": false, "message": status.message });
        }
    } catch (error) {
        console.error('Error updating task:', error);
        res.status(500).send({ "status": false, "message": "Internal Server Error" });
    }
}

module.exports = { postTask, getAllTasks, deleteTask, updateTask };
