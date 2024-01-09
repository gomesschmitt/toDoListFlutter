var express = require('express');

const router = express.Router();
const taskController = require('../src/tasks/taskController')
// Task Routes
router.route('/tasks/getAll').get(taskController.getAllTasks); // Adjusted route for tasks
router.route('/task').post(taskController.postTask); // Adjusted route for tasks
router.route('/task').delete(taskController.deleteTask); // Adjusted route for tasks
router.route('/task/edit/:id').patch(taskController.updateTask); // Adjusted route for tasks


module.exports = router;