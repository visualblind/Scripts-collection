Use the dpkg logs

locate dpkg.log | xargs cat {} | grep " install "

OR if you don't have locate

find /var/log/ -name 'dpkg.log' | xargs cat {} | grep " install "

Use sort to ensure proper time based ordering

locate dpkg.log | xargs cat {} | grep " install " | sort

Use tac (reverse cat)*, head e.g to get latest 4 entries

locate dpkg.log | xargs cat {} | grep " install " | sort | tac | head -n4