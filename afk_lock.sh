echo "if you're running this for the first time you might be asked to install 1 or 2 things"
gnome-screensaver -h || apt install gnome-screensaver
xdotool --help || sudo apt install xdotool

#config part
interval=5 #how many seconds the script waits after checking cursor location before checking again
lock_delay=30 #how many seconds it should wait to lock the screen
shut_delay=600 # how many seconds it should wait to initiate shutdown
#to disable shutdown make shut_delay a negative number smaller than negative interval, eg. interval=5 shut_delay=-6 

#get mouse location & store it as last mouse location
eval $(xdotool getmouselocation --shell)
px=$X
py=$Y

afk_time=0 #this will store the time passed since cursor last moved

checkCursor(){
eval $(xdotool getmouselocation --shell)

if [ $(($px - $X)) -eq 0 ] && [ $(($py - $Y)) -eq 0 ]
then
afk_time=$(( $afk_time + $interval ))
else
afk_time=0
fi

echo $afk_time
px=$X
py=$Y
}

tryLock(){
#this equation makes sure it will trigger only once, removes need for lock_delay to be a multiple of interval
if [ $(( $afk_time / $interval )) -eq $(( $lock_delay / $interval )) ]
then
gnome-screensaver-command -l
fi
if [ $(( $afk_time / $interval )) -eq $(( $shut_delay / $interval )) ]
then
shutdown -h now
fi
}

echo "script started succesfully"

while true
do
checkCursor
tryLock
sleep $interval
done
