// SPDX-FileCopyrightText: 2023 XWiki CryptPad Team <contact@cryptpad.org> and contributors
//
// SPDX-License-Identifier: AGPL-3.0-or-later

(() => {
const factory = (AppConfig) => {

    AppConfig.availablePadTypes = ['drive'];

    AppConfig.registeredOnlyTypes = ['file', 'contacts', 'notifications', 'support', 'teams', 'sheet', 'doc', 
        'presentation', 'pad', 'kanban', 'code', 'form', 'poll', 'whiteboard',
        'file', 'contacts', 'slide', 'convert', 'diagram'];
    AppConfig.surveyURL = "";

    return AppConfig;
};


// Do not change code below
if (typeof(module) !== 'undefined' && module.exports) {
    module.exports = factory(
        require('../www/common/application_config_internal.js')
    );
} else if ((typeof(define) !== 'undefined' && define !== null) && (define.amd !== null)) {
    define(['/common/application_config_internal.js'], factory);
}

})();