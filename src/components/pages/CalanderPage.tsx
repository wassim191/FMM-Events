import React, { useEffect, useState } from 'react';
import { Calendar } from 'antd';
import moment, { Moment } from 'moment';
import { CheckCircleOutlined, ClockCircleOutlined, CloseCircleOutlined } from '@ant-design/icons';

interface Event {
  id: number;
  instructorName: string;
  date: string;
  timeofstart: Moment;
  timeofend: Moment;
  status: string;
}

const CalendarPage: React.FC = () => {
  const [events, setEvents] = useState<Event[]>([]);

  useEffect(() => {
    fetchEvents();
  }, []);

  const fetchEvents = async () => {
    try {
      const response = await fetch('http://localhost:3002/getcourse');
      const eventData = await response.json();
      const formattedEvents = eventData.map((event: any) => ({
        id: event._id,
        instructorName: event.Prof,
        date: event.Date,
        timeofstart: moment(event.Timeofstart),
        timeofend: moment(event.Timeofend),
        status: event.status,
      }));
      setEvents(formattedEvents);
    } catch (error) {
      console.error('Error fetching events:', error);
    }
  };

  const generateEvent = (event: Event) => {
    let color = '';
    switch (event.status) {
      case 'pending':
        color = 'yellow';
        break;
      case 'active':
        color = 'green';
        break;
      case 'notactive':
        color = 'red';
        break;
      default:
        break;
    }

    const startTime = event.timeofstart.format('HH:mm');
    const endTime = event.timeofend.format('HH:mm');
    
    return {
      id: event.id,
      title: `${event.instructorName} ${startTime} -> ${endTime}`,
      start: moment(event.date, 'YYYY-MM-DD') as Moment,
      backgroundColor: color,
    };
  };

  const calendarEvents = events.map((event) => generateEvent(event));

  return (
    <div className="layout-content">
      <Calendar
        className="custom-calendar"
        dateCellRender={(value) => {
          const formattedDate = value.format('YYYY-MM-DD');
          const eventsOnDate = calendarEvents.filter((evt) => evt.start.format('YYYY-MM-DD') === formattedDate);
          if (eventsOnDate.length > 0) {
            return (
              <div>
                {eventsOnDate.map((event) => (
                  <div key={event.id} style={{ backgroundColor: event.backgroundColor, borderRadius: '8px', padding: '4px', marginBottom: '5px' }}>
                    {event.title}
                  </div>
                ))}
              </div>
            );
          }
          return null;
        }}
      />
    </div>
  );
};

export default CalendarPage;
