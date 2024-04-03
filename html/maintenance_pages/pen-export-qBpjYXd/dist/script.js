const countDown = () => {
            const countDay = new Date('December 28, 2022 00:00:00');
            const now = new Date();
            const counter = countDay - now;
            const second = 1000;
            const minute = second * 60;
            const hour = minute * 60;
            const day = hour * 24;
            const textDay = Math.floor(counter / day);
            const textHour = Math.floor((counter % day) / hour);
            const textMinute = Math.floor((counter % hour) / minute);
            const textSecond = Math.floor((counter % minute) / second)
            document.querySelector(".day").innerText = textDay + ' Days';
            document.querySelector(".hour").innerText = textHour + ' Hours';
            document.querySelector(".minute").innerText = textMinute + ' Minutes';
            document.querySelector(".second").innerText = textSecond + ' Seconds';
        }
        setInterval(countDown, 1000);