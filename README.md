# MeetingScheduler
This app show the meeting listing and scheduling meeting of the basis of start and end time.
When no date is selected or on first launch, fetch the schedule for today’s date.

NEXT Button: Tapping over this button will fetch the scheduled meetings (request from API) for next date<br />
PREV Button: Tapping over this button will fetch the scheduled meeting for prev date (request from API)<br />
Next & Prev buttons should skip non working days, so if weekends are off and it's a friday then clicking next should query for the next working day i.e monday.<br />

On tapping on the date label open up the date selection picker to picker data for the specific date.
<br />
```
Sample JSON
[
  {
    start_time: 11:00,
    end_time: 12:00,
    description: "development team of XYZ project: brainstorming session",
    participants: ["Ankit Gupta", "Manish kumar", "Shubham", "Sushant Sehgal"]
  },
  {
    start_time: 11:30,
    end_time: 12:00,
    description: "development team of XYZ project: brainstorming session",
    participants: ["Sahil Arora", "Ankita"]
  },
  {
    start_time: 9:00,
    end_time: 10:30,
    description: "development team of XYZ project: discussion session",
    participants: ["Sushant Sehgal"]
  }
]
```





