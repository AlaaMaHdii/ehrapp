var editor;

function capitalize(string) {
    // gør den første bogstav stor.
    return string.charAt(0).toUpperCase() + string.slice(1);
}

//  https://datatables.net/plug-ins/dataRender/datetime
$.fn.dataTable.render.moment = function ( from, to, locale ) {
    // Argument shifting
    if ( arguments.length === 1 ) {
        locale = 'da';
        to = from;
        from = 'YYYY-MM-DD hh:mm:ss.SSS';
    }
    else if ( arguments.length === 2 ) {
        locale = 'da';
    }

    return function ( d, type, row ) {
        if (! d) {
            return type === 'sort' || type === 'type' ? 0 : d;
        }

        var m = window.moment( d, from, locale, true );

        // Order and type get a number value from Moment, everything else
        // sees the rendered value
        return m.format( type === 'sort' || type === 'type' ? 'x' : to );
    };
};

// Start tabel når hjemmesiden er klar.
$(document).ready( function () {
    editor = new $.fn.dataTable.Editor({
        idSrc:  'id',
        table: "#personale",
        ajax: {
            create: {
                type: 'PUT',
                url:  '../rest/sundhedspersonale'
            },
            edit: {
                type: 'POST',
                url:  '../rest/sundhedspersonale?id={id}'
            },
            remove: {
                type: 'DELETE',
                url:  '../rest/sundhedspersonale?id={id}'
            }
        },
        fields: [
            {
                label: "Navn",
                name: "name"
            },
            {
                label: "Telefonnummer",
                name: "phoneNumber"
            },
            {
                label: "Stilling",
                name: "roles"
            },
            {
                label: "email",
                name: "email"
            },
            {
                label: "Adgangskode",
                name: "password"
            }
            ]
    });

    // Activate an inline edit on click of a table cell
    // tbody td.editable
    $('#personale').on( 'click', 'tbody td:not(:first-child)', function (e) {
        editor.inline( this, {
            buttons: { label: '&gt;', fn: function () { this.submit(); } }
        } );
    } );


    $('#personale').DataTable({
        ajax: '../rest/consultations',
        columns: [
            { data: 'name' },
            { data: 'phoneNumber' },
            { data: 'roles' },
            { data: 'email' },
            { data: 'password'}
        ],
        responsive: true,
        language: {
            url: '//cdn.datatables.net/plug-ins/1.12.1/i18n/da.json'
        },
        select: {
            info: false
        },
        dom: "Bfrtip",
        buttons: [ {
            extend: 'pdf',
            customize: function (doc) {
                // fix fra https://stackoverflow.com/questions/35642802/datatables-export-pdf-with-100-width
                doc.content[1].table.widths =
                    Array(doc.content[1].table.body[0].length + 1).join('*').split('');
            }
        }, 'excel',
            { extend: "create", editor: editor },
            { extend: "edit",   editor: editor },
            { extend: "remove", editor: editor }
        ]
    });
} );

