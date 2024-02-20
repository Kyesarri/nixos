import { clock } from '../../variables.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export default ({
    format = '%a %d %b',
    interval = 1000,
    ...rest
} = {}) => Widget.Label({
    class_name: 'date',
    label: clock.bind('value').transform(time => {return time.format(format)}),
        //return time.format(format) || 'yer nar nar yer'; }),
    ...rest,
});

/*
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export default ({     format = '%a %d %b',
} = {}) => 
    Widget.Label ({
        class_name: 'date',
    }) .poll(1000, label => label.label = Utils.exec('date'))

//    format = '%a %d %b',

/*const date = Variable('', {
    poll: [1000, 'date'],
})*/