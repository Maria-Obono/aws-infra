module.exports = app => {
    const Users = require("../controller/User.controllers");
  
    var router = require("express").Router();
  
    // Create a new User
    router.post("/", Users.create);
  
    // Retrieve all Users
    router.get("/", Users.findAll);
  
  
    // Retrieve a single Tutorial with id
    router.get("/:id", Users.findOne);
  
    // Update a Tutorial with id
    router.put("/:id", Users.update);
  
    // Delete a Tutorial with id
    router.delete("/:id", Users.delete);
  
    // Delete all Tutorials
    router.delete("/", Users.deleteAll);
  
    app.use('/api/Users', router);
  };