
## Redis - Simple Example

### Set and Get Data

``` delphi
// set
Redis.ServerAddress := '10.10.10.2'; // default is 127.0.0.1
Redis.Port := '6379';
Redis['yourkey'] := 'Your data string at ' + DateTimeToStr(now);

// get
s := Redis['yourkey'];
```

### Master Slave

read from slave, write to master
``` delphi
Redis := TRedisConstroller.Create;
Redis.WriteToMaster := True;
Redis.MasterPort := '10.10.10.1';
Redis.MasterPort := '6378';
```


[FastPlaz] - Fast Web Framework for Pascal


[FastPlaz]:http://www.fastplaz.com

