/*
 * Copyright (c) 2014 castLabs GmbH
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

package com.castlabs.dash.loaders {
import com.castlabs.dash.DashContext;
import com.castlabs.dash.descriptors.segments.DataSegment;
import com.castlabs.dash.descriptors.segments.ReflexiveSegment;
import com.castlabs.dash.descriptors.segments.Segment;
import com.castlabs.dash.events.SegmentEvent;

import flash.events.Event;
import flash.net.URLLoader;
import flash.utils.ByteArray;

public class ReflexiveSegmentLoader extends DataSegmentLoader {
    public function ReflexiveSegmentLoader(context:DashContext, segment:Segment) {
        super(context, segment);
    }

    override protected function onComplete(event:Event):void {
		_context.console.debug("Loaded segment, url='" + getUrl() + "', status='" + _status + "'");
		
        if (DataSegment(_segment).isRange && _status == 200) {
            _context.console.error("Partial content wasn't returned. Please make sure that range requests " +
                    "are handle properly on the server side: https://github.com/castlabs/dashas/wiki/htaccess");
            dispatchEvent(_context.buildSegmentEvent(SegmentEvent.ERROR));
            return;
        }
		
        var bytes:ByteArray = URLLoader(event.target).data;
        ReflexiveSegment(_segment).callback(bytes);
		dispatchEvent(_context.buildSegmentEvent(SegmentEvent.LOADED, false, false, _segment, bytes));
    }
}
}
