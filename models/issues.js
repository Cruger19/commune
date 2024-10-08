const db = require('../CONFIG/db');

const Issue = {
  create: (user_id, description, location, callback) => {
    const query = 'INSERT INTO issues (user_id, description, location) VALUES (?, ?, ?)';
    db.query(query, [user_id, description, location], callback);
  },

  findByUser: (user_id, callback) => {
    const query = 'SELECT * FROM issues WHERE user_id = ?';
    db.query(query, [user_id], callback);
  },

  updateStatus: (issue_id, status, callback) => {
    const query = 'UPDATE issues SET status = ? WHERE id = ?';
    db.query(query, [status, issue_id], callback);
  }
};

module.exports = Issue;
