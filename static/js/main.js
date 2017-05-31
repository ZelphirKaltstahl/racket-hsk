$(document).ready(function() {
    // var ajax_loader = ;
    console.log('LOADED');
    HSK.get_vocabulary('1').done((data) => {
        console.log('AJAX SUCCESS')
        HSK.render_words_list(data['words']);
        HSK.register_event_listeners();

    }).fail((data) => {
        console.log('AJAX FAILED');

    }).always((data) => {
        console.log('AJAX FINISHED (success / fail)');
    });

});

var HSK = {
    get_vocabulary: function (level) {
        return $.getJSON('ajax/hsk-' + level + '-data');
    },

    // METADATA
    word_id: function (word) {
        return word.metadata.id;
    },
    word_learned: function (word) {
        return word['metadata']['learned'];
    },
    word_description: function (word) {
        return word['metadata']['description'];
    },

    // TRANSLATION DATA
    word_english: function (word) {
        return word['translation-data']['english'];
    },
    word_pinyin: function (word) {
        return word['translation-data']['pinyin'];
    },
    word_pinyin_numbered: function (word) {
        return word['translation-data']['pinyin-numbered'];
    },
    word_simplified: function (word) {
        return word['translation-data']['simplified'];
    },
    word_traditional: function (word) {
        return word['translation-data']['traditional'];
    },

    // RENDERING
    render_word_table: function (word) {
        function render_hanci (hanci) {
            function render_hanzi (hanzi) {
                var hanzi_container = $('<div/>', {class: 'hanzi-container'});
                var hanzi = $('<p>' + hanzi + '</p>', {class: 'hanzi'});
                return hanzi_container.append(hanzi);
            }
            return _.map(hanci.split(''), render_hanzi);
        }

        var words_container = $('<div/>').addClass('words-container');

        var word_table_container = $('<div/>', {
            id: 'word-' + HSK.word_id(word),
            class: 'word-table-container'});

        var word_table = $('<table/>', {class: 'word-table'});

        var row = () => $('<tr/>');
        var cell = () => $('<td/>');

        var latin_letter_cell = () => cell().addClass('latinletters-cell');

        var english_label = $('<p>English:</p>', {class: 'word-attribute-label'});
        var english_data = $('<p>' + HSK.word_english(word) + '</p>');

        var pinyin_label = $('<p>Pīnyīn:</p>', {class: 'word-attribute-label'});
        var pinyin_data = $('<p>' + HSK.word_pinyin(word) + '</p>');

        var hanci_cell = () => cell().addClass('hanci-cell');

        var container = () => $('<div/>');
        var float_right_container = () => container().addClass('float-right-container');
        var hanzi_hide_container = () => container().addClass('hanzi-hide-container');

        var simplified_hanzi_list = render_hanci(HSK.word_simplified(word));
        var traditional_hanzi_list = render_hanci(HSK.word_traditional(word));

        var word_id_label = $('<p>id: <span class="word_id">' + HSK.word_id(word) + '</span></p>')
            .addClass('word-id-label');

        var image = (a_src, a_class) => $('<img src="' + a_src + '"/>').addClass(a_class);
        var word_controls_image = (a_src) => {
            return image(a_src, 'word-controls-image');
        };

        return words_container
            .append(word_table_container
                    .append(word_table
                            .append(row()
                                    .append(latin_letter_cell()
                                            .append(container()
                                                    .append(english_label)
                                                    .append(english_data)))
                                    .append(hanci_cell()
                                            .append(float_right_container()
                                                    .append(hanzi_hide_container()
                                                            .append(simplified_hanzi_list)))))
                            .append(row()
                                    .append(latin_letter_cell()
                                            .append(container()
                                                    .append(pinyin_label)
                                                    .append(pinyin_data)))
                                    .append(hanci_cell()
                                            .append(float_right_container()
                                                    .append(hanzi_hide_container()
                                                            .append(traditional_hanzi_list)))))
                            .append(row()
                                    .append(cell().append(word_id_label))
                                    .append(cell()
                                            .append(float_right_container()
                                                    .append(word_controls_image('/img/word-explain.svg').addClass('word-explain-image'))
                                                    .append(word_controls_image('/img/word-not-memorized.svg'))
                                                    .append(word_controls_image('/img/word-memorized.svg')))))));
    },

    render_words_list: function (words) {
        _.each(words, (word) => {
            $('.content-container').append(HSK.render_word_table(word));
        });
    },

    show_description: function (a_word) {
        console.log('SHOWING DESCRIPTION', a_word);
    },

    register_event_listeners: function () {
        $('.word-explain-image').on(
            'click',
            (event) => {
                var element = event.target;
                var word_id = $(element).parents('tr').find('.word_id').text();
                HSK.show_description(word_id);
            }
        );
    }
}
