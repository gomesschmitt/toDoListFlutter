const client = require('../../db');

const myDB = client.db("flutterList"); 
const myColl = myDB.collection("list"); 

const insertTask = async (taskId) => {
  const taskExists = await myColl.findOne({ id: taskId });
  if (taskExists) {
    throw new Error(`Task already exists for the id: ${taskId}`);
  }

  const task = {
    id: taskId
  };
  const result = await myColl.insertOne(task);
  return result;
}

const getAllTasks = async () => {
  const result = await myColl.find({}).toArray();
  return result;
}

const deleteTask = async (taskId) => {
  const result = await myColl.deleteOne({ id: taskId });
  return result;
}

const updateTask = async (taskId, updatedFields) => {
  const existingTask = await myColl.findOne({ id: taskId });
  if (!existingTask) {
    throw new Error(`Task not found with the id: ${taskId}`);
  }

  const allowedFields = ['id'];
  const updateData = {};
  for (const field of allowedFields) {
    if (updatedFields[field] !== undefined) {
      updateData[field] = updatedFields[field];
    }
  }

  const result = await myColl.updateOne({ id: taskId }, { $set: updateData });

  if (result.modifiedCount > 0) {
    return { status: true, message: 'Task updated successfully' };
  } else {
    return { status: false, message: 'No changes detected. Task may not have been updated.' };
  }
}

module.exports = { insertTask, getAllTasks, deleteTask, updateTask };
