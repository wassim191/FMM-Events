// components/HomePage.tsx
import { Button, Card, Col, Row, Statistic } from 'antd';
import React from 'react';
import DialChart from '../pages/charts/DialChart';

const HomePage: React.FC = () => {
  // Mock data for active users and course statistics
  const activeUsers = 1500; // Example number of active users
  const totalInstructors = 50; // Example number of instructors
  const totalLearners = 1000; // Example number of learners
  const totalAdmins = 20; // Example number of admins
  const totalCourses = 200; // Example total number of courses
  const coursesPending = 30; // Example number of courses pending approval
  const coursesApproved = 150; // Example number of courses approved

  return (
    <div style={{ padding: '20px' }}>
      <h1>Welcome to the Admin Dashboard</h1>
      <p>Here you can manage courses, registrations, and other tasks related to course management.</p>
      <Row gutter={16} style={{ marginBottom: '20px' }}>
        <Col span={8}>
          <Card>
            <Statistic title="Total Courses" value={totalCourses} />
          </Card>
        </Col>
        <Col span={8}>
          <Card>
            <Statistic title="Courses Pending" value={coursesPending} />
          </Card>
        </Col>
        <Col span={8}>
          <Card>
            <Statistic title="Courses Approved" value={coursesApproved} />
          </Card>
        </Col>
      </Row>
      <Row gutter={16} style={{ marginBottom: '20px' }}>
      <Col span={8}>
  <Card>
    <DialChart
      title="Active Users"
      value={activeUsers}
      maxValue={2000}
      color="#52c41a" // Change color here
      size={120} // Change size here
    />
  </Card>
</Col>
<Col span={8}>
  <Card>
    <DialChart
      title="Instructors"
      value={totalInstructors}
      maxValue={100}
      color="#faad14" // Change color here
      size={120} // Change size here
    />
  </Card>
</Col>
<Col span={8}>
  <Card>
    <DialChart
      title="Learners"
      value={totalLearners}
      maxValue={2000}
      color="#1890ff" // Change color here
      size={120} // Change size here
    />
  </Card>
</Col>
<Col span={8}>
  <Card>
    <DialChart
      title="Admins"
      value={totalAdmins}
      maxValue={50}
      color="#eb2f96" // Change color here
      size={120} // Change size here
    />
  </Card>
</Col>

      </Row>
    </div>
  );
};

export default HomePage;