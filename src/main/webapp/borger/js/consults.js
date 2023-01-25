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
$(document).ready( async function () {


    editor = new $.fn.dataTable.Editor({
        idSrc: 'id',
        table: "#consults",
        ajax: {
            create: {
                type: 'PUT',
                url: '../rest/borgerConsultations'
            },
            edit: {
                type: 'POST',
                url: '../rest/borgerConsultations?id={id}'
            },
            remove: {
                type: 'DELETE',
                url: '../rest/borgerConsultations?id={id}'
            }
        },
        fields: [
            {
                label: "Læge",
                name: "idOfDoctor",
                type: "select",
                options: await $.getJSON('../rest/getDoctors'),
            },
            {
                label: "Dato",
                name: "startDate",
                type: "datetime",
                displayFormat: "YYYY-MM-DD HH:mm",
                wireFormat: "YYYY-MM-DD HH:mm",
                opts: {
                    minutesAvailable: [0, 15, 30, 45],
                    disableDays: [0,6],
                    hoursAvailable: [8, 9, 10, 11, 12, 13, 14, 15, 16]
                }
            },
            {
                label: "Note",
                name: "note"
            }]
    });

    // Activate an inline edit on click of a table cell
    // tbody td.editable
    $('#consults').on('click', 'tbody td:not(:first-child)', function (e) {
        editor.inline(this, {
            buttons: {
                label: '&gt;', fn: function () {
                    this.submit();
                }
            }
        });
    });


    $('#consults').DataTable({
        ajax: '../rest/borgerConsultations',
        columns: [
            {data: 'patientName'},
            {data: 'cpr'},
            {
                data: 'startDate',
                render: $.fn.dataTable.render.moment('YYYY-MM-DD HH:mm:ss.SSSS', 'YYYY-MM-DD HH:mm', 'da')
            },
            {
                data: 'duration', render: function (data, type, row, meta) {
                    if (type === 'display') {
                        return capitalize(moment.duration({"seconds": data}).humanize());
                    }
                    return data;
                }
            },
            {data: 'note', className: 'editable'},
        ],
        responsive: true,
        language: {
            url: '//cdn.datatables.net/plug-ins/1.12.1/i18n/da.json'
        },
        select: {
            info: false
        },
        dom: "Bfrtip",
        buttons: [{
            extend: 'pdf',
            customize: function (doc) {
                // fix fra https://stackoverflow.com/questions/35642802/datatables-export-pdf-with-100-width
                doc.content[1].table.widths =
                    Array(doc.content[1].table.body[0].length + 1).join('*').split('');
            }
        }, 'excel',
            {extend: "create", editor: editor},
            {extend: "edit", editor: editor},
            {extend: "remove", text: 'Afbestil',  editor: editor}
        ]
    });

} );

