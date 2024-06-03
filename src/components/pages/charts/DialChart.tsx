// components/charts/DialChart.tsx
import React from 'react';

interface DialChartProps {
  value: number;
  maxValue: number;
  size: number;
  title?: string; // Make the title prop optional
  color?: string; // Make the color prop optional
}

const DialChart: React.FC<DialChartProps> = ({ value, maxValue, size, title, color }) => {
  const radius = size / 2;
  const strokeWidth = 10;
  const circumference = 2 * Math.PI * radius;
  const progress = (value / maxValue) * circumference;
  const remaining = circumference - progress;

  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
      <circle
        cx={radius}
        cy={radius}
        r={radius - strokeWidth / 2}
        fill="none"
        stroke="#f0f0f0"
        strokeWidth={strokeWidth}
      />
      <circle
        cx={radius}
        cy={radius}
        r={radius - strokeWidth / 2}
        fill="none"
        stroke={color || '#1890ff'} // Use the provided color or default to '#1890ff'
        strokeWidth={strokeWidth}
        strokeDasharray={`${progress} ${remaining}`}
        transform={`rotate(-90 ${radius} ${radius})`}
      />
      <text x={radius} y={radius + 10} textAnchor="middle" dominantBaseline="middle" fontSize="12" fill={color || '#1890ff'}>
        {title && `${title}: `}
        {value}
      </text>
    </svg>
  );
};

export default DialChart;