const Issue = require('../models/Issue');

exports.createIssue = (req, res) => {
  const { description, location } = req.body;
  const user_id = req.user.id;

  Issue.create(user_id, description, location, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ message: 'Issue reported successfully' });
  });
};

exports.getIssuesByUser = (req, res) => {
  const user_id = req.user.id;

  Issue.findByUser(user_id, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(result);
  });
};

exports.updateIssueStatus = (req, res) => {
  const { issue_id, status } = req.body;

  Issue.updateStatus(issue_id, status, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Issue status updated successfully' });
  });
};

document.getElementById('issue-form').addEventListener('submit', function (event) {
  event.preventDefault();

  const description = document.getElementById('description').value.trim();
  const location = document.getElementById('location').value.trim();

  if (!description || !location) {
    alert('Please fill in all fields.');
    return;
  }

  // Proceed with form submission...
});
