(function($){
    const path = window.location.pathname.replace(/\/$/, '');
    const cookieName = 'datatable_length_' + path;

    function setCookie(name, value, days){
        let expires = "";
        if(days){
            const date = new Date();
            date.setTime(date.getTime() + (days*24*60*60*1000));
            expires = '; expires=' + date.toUTCString();
        }
        document.cookie = name + '=' + value + expires + '; path=/';
    }

    function getCookie(name){
        const nameEQ = name + '=';
        const ca = document.cookie.split(';');
        for(let i=0;i<ca.length;i++){
            let c = ca[i];
            while(c.charAt(0) === ' ') c = c.substring(1,c.length);
            if(c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length,c.length);
        }
        return null;
    }

    const savedLength = parseInt(getCookie(cookieName), 10);
    if(!isNaN(savedLength)){
        $.fn.dataTable.defaults.pageLength = savedLength;
    }

    $(document).on('length.dt', function(e, settings, len){
        setCookie(cookieName, len, 365);
    });
})(jQuery);