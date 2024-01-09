var taskRepository = require('./taskRepository');

const createTask = async (taskId) => {
    const response = await taskRepository.insertTask(taskId);
    return response;
}

const getAllTasks = async () => {
    const response = await taskRepository.getAllTasks();
    return response;
}

const removeTask = async (taskId) => {
    const response = await taskRepository.deleteTask(taskId);
    return response;
}

const updateTask = async (taskId, updatedFields) => {
    const response = await taskRepository.updateTask(taskId, updatedFields);
    return response;
};

module.exports = { createTask, getAllTasks, removeTask, updateTask };