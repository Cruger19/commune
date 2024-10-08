const mysql = require('mysql2');
const dotenv = require('dotenv');

// Load environment variables from .env file
dotenv.config();

// Create a connection to MySQL
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});

// Connect to MySQL
db.connect(err => {
  if (err) {
    console.error('Database connection failed:', err.message);
    process.exit(1);
  }
  console.log('Connected to the MySQL database');

  // Create database and table
  const createDbSql = 'CREATE DATABASE IF NOT EXISTS my_database';
  const useDbSql = 'USE my_database';
  const createTableSql = `
    CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100),
      email VARCHAR(100) UNIQUE
    )
  `;

  // Create the database
  db.query(createDbSql, (err, results) => {
    if (err) {
      console.error('Error creating database:', err);
      return;
    }
    console.log('Database created or already exists:', results);

    // Switch to the new database
    db.query(useDbSql, (err) => {
      if (err) {
        console.error('Error using database:', err);
        return;
      }

      // Create the table
      db.query(createTableSql, (err, results) => {
        if (err) {
          console.error('Error creating table:', err);
          return;
        }
        console.log('Table created or already exists:', results);

        // Close the connection after all queries are done
        db.end();
      });
    });
  });
});
