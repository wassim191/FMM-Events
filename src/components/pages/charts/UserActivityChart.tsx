import React from 'react';

const UserDistributionChart = () => {
  const data = {
    Learners: 100,
    Instructors: 50,
    Admins: 10,
  };
  
  const config = {
    appendPadding: 10,
    data: Object.entries(data).map(([category, count]): { type: string; value: number } => ({ type: category, value: count })),
    angleField: 'value',
    colorField: 'type',
    radius: 0.8,
    label: {
        pointRadius: 2,
          borderWidth: 2,
      fill: false,
      style: { textAlign: 'center' },
      autoRotate: false,
      content: (data: { value: any; }) => data.value, // Access value from the data object
    },
    interactions: [{ type: 'element-active' }],
  };
  
  
  

};

export default UserDistributionChart;